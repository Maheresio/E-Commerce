import '../../../../core/helpers/extensions/theme_color.extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/product_entity.dart';
import 'product_details_view_body.dart';
import '../../../../core/widgets/product_info_tile.dart';
import 'read_only_text_field.dart';

class SizeColorFavoriteSelector extends StatelessWidget {
  const SizeColorFavoriteSelector({
    super.key,
    required this.sizes,
    required this.product,
  });

  final List<String> sizes;
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: ReadOnlyTextFormField(
            value: AppStrings.kSizes,
            onTap: () async {
              debugPrint('Sizes');
              await showModalBottomSheet(
                showDragHandle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                context: context,
                builder:
                    (context) => SizedBox(
                      width: double.infinity,
                      height: 280.h,

                      child: Column(
                        children: [
                          Text(
                            'Select Size',
                            style: AppStyles.font18BlackSemiBold,
                          ),
                          SizedBox(height: 22),
                          Wrap(
                            runSpacing: 16,
                            spacing: 22.w,
                            children:
                                sizes
                                    .map(
                                      (size) => InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 40.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                              color: context.color.secondary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                size,
                                                style: AppStyles
                                                    .font14BlackMedium
                                                    .copyWith(height: 1.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          SizedBox(height: 24),
                          ProductInfoTile(
                            title: AppStrings.kSizeInfo,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),
        ),
        Expanded(
          child: ReadOnlyTextFormField(value: AppStrings.kColor, onTap: () {}),
        ),
        ProductDetailsFavoriteWidget(
          id: product.id,
          isFavorite: product.isFavorite,
        ),
      ],
    );
  }
}

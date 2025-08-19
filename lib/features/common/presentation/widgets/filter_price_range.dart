import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../shop/presentation/controller/filter_models.dart';

class FilterPriceRange extends ConsumerWidget {
  const FilterPriceRange({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FilterParams tempFilterParams = ref.watch(tempFilterParamsProvider);
    final double? minPrice = tempFilterParams.priceMin;
    final double? maxPrice = tempFilterParams.priceMax;
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(
            AppStrings.kPriceRange,
            style: AppStyles.font16BlackSemiBold(context),
          ),
        ),
        Material(
          elevation: 1,
          child: ColoredBox(
            color: context.color.onSecondary,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12.h,
                horizontal: horizontalPadding,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '\$${minPrice!.toStringAsFixed(0)}',
                        style: AppStyles.font14BlackMedium(context),
                      ),
                      Text(
                        '\$${maxPrice!.toStringAsFixed(0)}',
                        style: AppStyles.font14BlackMedium(context),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    max: 10000,
                    labels: RangeLabels(
                      minPrice.toStringAsFixed(0),
                      maxPrice.toStringAsFixed(0),
                    ),

                    onChanged: (newValues) {
                      ref
                          .read(tempFilterParamsProvider.notifier)
                          .update(
                            (FilterParams old) => old.copyWith(
                              priceMin: newValues.start,
                              priceMax: newValues.end,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

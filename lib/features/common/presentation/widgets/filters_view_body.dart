import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'filter_brands.dart';
import 'filter_category.dart';
import 'filter_colors.dart';
import 'filter_price_range.dart';
import 'filter_sizes.dart';

class FiltersViewBody extends ConsumerStatefulWidget {
  const FiltersViewBody({super.key});

  @override
  ConsumerState<FiltersViewBody> createState() => _FiltersViewBodyState();
}

class _FiltersViewBodyState extends ConsumerState<FiltersViewBody> {
  final double horizontalPadding = 16.w;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    padding: EdgeInsets.symmetric(vertical: 24.h),
    child: Column(
      spacing: 14,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterPriceRange(horizontalPadding: horizontalPadding),

        FilterColors(horizontalPadding: horizontalPadding),

        FilterSizes(horizontalPadding: horizontalPadding),

        FilterCategory(horizontalPadding: horizontalPadding),

        FilterBrands(horizontalPadding: horizontalPadding),
      ],
    ),
  );
}

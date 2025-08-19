import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/methods/product_lists.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../shop/presentation/controller/filter_models.dart';

class FilterCategory extends ConsumerWidget {
  const FilterCategory({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FilterTitle(horizontalPadding: horizontalPadding),
      _FilterCategoryGrid(horizontalPadding: horizontalPadding),
    ],
  );
}

class _FilterTitle extends StatelessWidget {
  const _FilterTitle({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Text(
      AppStrings.kCategory,
      style: AppStyles.font16BlackSemiBold(context),
    ),
  );
}

class _FilterCategoryGrid extends ConsumerWidget {
  const _FilterCategoryGrid({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String selectedGender = ref.watch(tempFilterParamsProvider).gender;

    return Material(
      elevation: 1,
      child: Container(
        width: double.infinity,
        color: context.color.onSecondary,
        padding: EdgeInsets.symmetric(
          vertical: 24.h,
          horizontal: horizontalPadding,
        ),
        child: Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children:
              uiCategories
                  .map(
                    (String category) => _FilterCategoryChip(
                      category: category,
                      selectedGender: selectedGender,
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class _FilterCategoryChip extends ConsumerWidget {
  const _FilterCategoryChip({
    required this.category,
    required this.selectedGender,
  });

  final String category;
  final String? selectedGender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSelected = selectedGender == category.toLowerCase();
    final themeColors = context.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 40.h,
      width: 100.w,
      decoration: BoxDecoration(
          color: isSelected ? themeColors.primary : themeColors.onSecondary,
        borderRadius: BorderRadius.circular(8.r),
        border:
            isSelected
                ? null
                : Border.all(
                  color: themeColors.primary.withValues(alpha: 0.3),
                ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: () => _onCategoryTap(ref, category),
          borderRadius: BorderRadius.circular(8.r),
          child: Center(
            child: FittedBox(
              child: Text(
                category,
                textAlign: TextAlign.center,
                style:
                    isSelected
                        ? AppStyles.font14WhiteMedium(context)
                        : AppStyles.font14BlackMedium(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(WidgetRef ref, String category) {
    ref
        .read(tempFilterParamsProvider.notifier)
        .update(
          (FilterParams param) =>
              param.copyWith(gender: category.toLowerCase()),
        );
  }
}

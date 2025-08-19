import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/methods/product_lists.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../shop/presentation/controller/filter_models.dart';

class FilterSizes extends ConsumerWidget {
  const FilterSizes({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> sizes =
        ref.watch(tempFilterParamsProvider).sizes ?? <String>[];

    return Column(
      spacing: 12.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FilterTitle(horizontalPadding: horizontalPadding),
        _SizeSelector(
          horizontalPadding: horizontalPadding,
          selectedSizes: sizes,
        ),
      ],
    );
  }
}

class _FilterTitle extends StatelessWidget {
  const _FilterTitle({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Text(
      AppStrings.kSizes,
      style: AppStyles.font16BlackSemiBold(context),
    ),
  );
}

class _SizeSelector extends ConsumerWidget {
  const _SizeSelector({
    required this.horizontalPadding,
    required this.selectedSizes,
  });

  final double horizontalPadding;
  final List<String> selectedSizes;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
    elevation: 1,
    borderRadius: BorderRadius.circular(8.r),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.color.onSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          vertical: 24.h,
          horizontal: horizontalPadding,
        ),
        child: Row(
          spacing: 12.w,
          children:
              uiSizes
                  .map(
                    (size) => _SizeChip(
                      size: size,
                      isSelected: selectedSizes.contains(size),
                    ),
                  )
                  .toList(),
        ),
      ),
    ),
  );
}

class _SizeChip extends ConsumerWidget {
  const _SizeChip({required this.size, required this.isSelected});

  final String size;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = context.color;
    return InkWell(
    onTap: () => _toggleSize(ref, size),
    borderRadius: BorderRadius.circular(8.r),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 45.h,
      width: 45.w,
      decoration: BoxDecoration(
        border:
            !isSelected
                ? Border.all(
                  color: themeColors.secondary.withValues(alpha: 0.3),
                  width: 1.w,
                )
                : null,
        color: isSelected ? themeColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            size,
            textAlign: TextAlign.center,
            style:
                isSelected
                    ? AppStyles.font14WhiteMedium(context)
                    : AppStyles.font14BlackMedium(context),
          ),
        ),
      ),
    ),
  );
  }

  void _toggleSize(WidgetRef ref, String size) {
    ref.read(tempFilterParamsProvider.notifier).update((FilterParams param) {
      final List<String> currentSizes = param.sizes ?? <String>[];
      final List<String> updatedSizes = List<String>.from(currentSizes);

      if (updatedSizes.contains(size)) {
        updatedSizes.remove(size);
      } else {
        updatedSizes.add(size);
      }

      return param.copyWith(sizes: updatedSizes);
    });
  }
}

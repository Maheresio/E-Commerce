import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../../../../core/helpers/methods/product_lists.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../shop/presentation/controller/filter_models.dart';

class FilterColors extends ConsumerWidget {
  const FilterColors({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    spacing: 12,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _FilterTitle(horizontalPadding: horizontalPadding),
      _FilterColorsList(horizontalPadding: horizontalPadding),
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
      AppStrings.kColors,
      style: AppStyles.font16BlackSemiBold(context),
    ),
  );
}

class _FilterColorsList extends ConsumerWidget {
  const _FilterColorsList({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
    elevation: 1,
    child: ColoredBox(
      color: context.color.onSecondary,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 26.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              spacing: 12.w,
              children:
                  uiColors.map((color) => _ColorItem(color: color)).toList(),
            ),
          ),
        ),
      ),
    ),
  );
}

class _ColorItem extends ConsumerWidget {
  const _ColorItem({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> selectedColors =
        ref.watch(tempFilterParamsProvider).colors ?? <String>[];
    final bool isSelected = selectedColors.contains(
      colorLogicMap[color]!.first,
    );
    final s = isSelected ? 1.0 : 0.95;
    final themeColors = context.color;

    return GestureDetector(
      onTap: () => _toggleColorSelection(ref),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 45.w,
        height: 45.h,
        transform: Matrix4.identity()..scaleByVector3(vm.Vector3(s, s, 1.0)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: themeColors.onPrimary.withValues(alpha: 0.05),
              spreadRadius: 0.05,
            ),
          ],
          border: Border.all(
            color: isSelected ? themeColors.primary : Colors.transparent,
            width: 2.w,
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }

  void _toggleColorSelection(WidgetRef ref) {
    ref.read(tempFilterParamsProvider.notifier).update((FilterParams param) {
      final List<String> currentColors = param.colors ?? <String>[];
      final List<String> updatedColors = List<String>.from(currentColors);

      if (updatedColors.contains(colorLogicMap[color]!.first)) {
        updatedColors.remove(colorLogicMap[color]!.first);
      } else {
        updatedColors.add(colorLogicMap[color]!.first);
      }

      return param.copyWith(colors: updatedColors);
    });
  }
}

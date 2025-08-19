import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../core/helpers/methods/product_lists.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../shop/presentation/controller/filter_models.dart';

class FilterBrands extends ConsumerWidget {
  const FilterBrands({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: ListTile(
      onTap: () async {
        final result = await _showDialog(context, ref);

        if (result != null) {
          ref
              .read(tempFilterParamsProvider.notifier)
              .update((state) => state.copyWith(brands: result));
        }
      },
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        AppStrings.kBrand,
        style: AppStyles.font16BlackSemiBold(context),
      ),
      subtitle: Text(
        ref.watch(tempFilterParamsProvider).brands!.isEmpty
            ? AppStrings.kSelectBrands
            : ref.watch(tempFilterParamsProvider).brands!.join(', '),
        style: AppStyles.font12GreyMedium(context),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 20.sp,
        color: context.color.primaryFixed,
      ),
    ),
  );

  Future<dynamic> _showDialog(BuildContext context, WidgetRef ref) =>
      showDialog(
        context: context,
        builder:
            (context) => MultiSelectDialog(
              items: brands.map((e) => MultiSelectItem(e, e)).toList(),
              initialValue: ref.watch(tempFilterParamsProvider).brands!,
              title: Text(
                AppStrings.kSelectBrands,
                style: AppStyles.font16BlackSemiBold(context),
              ),
              searchable: true,
              searchIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
              itemsTextStyle: AppStyles.font16BlackRegular(context),
              selectedColor: context.color.primary,
              selectedItemsTextStyle: AppStyles.font16PrimarySemiBold(context),
              searchHint: AppStrings.kSearch,
              searchHintStyle: AppStyles.font16GreyRegular(context),
              searchTextStyle: AppStyles.font16BlackMedium(context),
              cancelText: Text(
                AppStrings.kCancel,
                style: AppStyles.font14PrimaryMedium(context),
              ),
              confirmText: Text(
                AppStrings.kApply,
                style: AppStyles.font14PrimaryMedium(context),
              ),
            ),
      );
}

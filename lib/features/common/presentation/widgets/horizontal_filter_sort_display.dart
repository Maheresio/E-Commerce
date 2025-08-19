import '../../../../core/helpers/extensions/context_extensions.dart';
import '../controller/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../shop/presentation/controller/filter_models.dart';
import '../../../shop/presentation/controller/pagination_async_notifier.dart';
import '../../helpers/handle_sort_products.dart';

class HorizontalFilterSortDisplay extends StatelessWidget {
  const HorizontalFilterSortDisplay(this.notifier, {super.key});

  final PaginationAsyncNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final themeColors= context.color;
    return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: ColoredBox(
      color: themeColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => context.push(AppRouter.kFilterView),
  
            child: Row(
              spacing: 10,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 24.sp,
                  color: themeColors.primaryFixed,
                ),
                Text(
                  AppStrings.kFilters,
                  style: AppStyles.font12BlackMedium(context),
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return InkWell(
                onTap: () {
                  sortModelSheet(context, ref, notifier);
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.swap_vert_outlined,
                      size: 24.sp,
                      color: themeColors.primaryFixed,
                    ),
                    Text(
                      ref.watch(filterParamsProvider).sortBy!.displayName,
                      style: AppStyles.font12BlackMedium(context),
                    ),
                  ],
                ),
              );
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              return InkWell(
                onTap: () {
                  ref.read(isGridViewModeProvider.notifier).toggle();
                },
                child: Icon(
                  ref.watch(isGridViewModeProvider)
                      ? Icons.list_outlined
                      : Icons.grid_view_outlined,
                  size: 24.sp,
                  color: themeColors.primaryFixed,
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
  }
}

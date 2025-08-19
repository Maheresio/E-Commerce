import 'package:e_commerce/core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../../core/utils/app_strings.dart';
import '../../../core/utils/app_styles.dart';
import '../../shop/presentation/controller/filter_models.dart';
import '../../shop/presentation/controller/pagination_async_notifier.dart';

Future<void> sortModelSheet(
  BuildContext context,
  WidgetRef ref,
  PaginationAsyncNotifier notifier,
) async {
  final themeColors = context.color;

  await Navigator.of(context).push(
    ModalSheetRoute(
      barrierDismissible: true,
      swipeDismissible: true,
      swipeDismissSensitivity: const SwipeDismissSensitivity(
        minDragDistance: 0,
      ),
      builder:
          (context) => Sheet(
            physics: const BouncingSheetPhysics(),
            child: SafeArea(
              top: false,
              child: Material(
                color: themeColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        12,
                        0,
                        MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Handle the sheet drag handle
                          Container(
                            width: 36,
                            height: 4,
                            margin: const EdgeInsets.only(
                              bottom: 8,
                            ), // Adjusted margin
                            decoration: BoxDecoration(
                              color: themeColors.secondary.withValues(
                                alpha: 0.25,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          // Title for the sheet
                          Text(
                            AppStrings.kSortBy,
                            style: AppStyles.font18BlackSemiBold(context),
                          ),
                          // Removed extra SizedBox to reduce space between text and options
                          Column(
                            children: [
                              ...[
                                AppStrings.kPopular,
                                AppStrings.kNewest,
                                AppStrings.kCustomerReview,
                                AppStrings.kPriceLowestToHigh,
                                AppStrings.kPriceHighestToLow,
                              ].map((option) {
                                return ListTile(
                                  dense: true,

                                  title: Text(
                                    option,
                                    style: AppStyles.font14BlackMedium(context),
                                  ),
                                  onTap: () {
                                    _handleSortOption(option, ref);
                                    Navigator.pop(context); // Dismiss the sheet
                                    notifier.reSort(); // Perform re-sort
                                  },
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
    ),
  );
}

void _handleSortOption(String option, WidgetRef ref) {
  switch (option) {
    case AppStrings.kPopular:
      ref
          .read(filterParamsProvider.notifier)
          .update(
            (FilterParams state) =>
                state.copyWith(sortBy: SortOption.popularity),
          );
      break;
    case AppStrings.kNewest:
      ref
          .read(filterParamsProvider.notifier)
          .update(
            (FilterParams state) => state.copyWith(sortBy: SortOption.newest),
          );
      break;
    case AppStrings.kCustomerReview:
      ref
          .read(filterParamsProvider.notifier)
          .update(
            (FilterParams state) =>
                state.copyWith(sortBy: SortOption.customerReview),
          );
      break;
    case AppStrings.kPriceLowestToHigh:
      ref
          .read(filterParamsProvider.notifier)
          .update(
            (FilterParams state) =>
                state.copyWith(sortBy: SortOption.priceLowToHigh),
          );
      break;
    case AppStrings.kPriceHighestToLow:
      ref
          .read(filterParamsProvider.notifier)
          .update(
            (FilterParams state) =>
                state.copyWith(sortBy: SortOption.priceHighToLow),
          );
      break;
  }
}

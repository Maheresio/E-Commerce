import 'package:animations/animations.dart';
import 'package:e_commerce/core/helpers/methods/styled_snack_bar.dart';
import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:e_commerce/core/widgets/styled_loading.dart';
import 'package:e_commerce/features/common/presentation/widgets/see_all_shimmer.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../shop/presentation/controller/pagination_async_notifier.dart';
import '../controller/product_provider.dart';
import 'horizontal_filter_sort_display.dart';
import 'see_all_grid_view.dart';
import 'see_all_list_view.dart';

class SeeAllViewBody extends HookConsumerWidget {
  const SeeAllViewBody({
    super.key,
    required this.provider,
    this.notifierProvider,
    this.enablePagination = true,
  });
  final ProviderListenable<AsyncValue<List<ProductEntity>>> provider;
  final ProviderListenable<PaginationAsyncNotifier>? notifierProvider;
  final bool enablePagination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ProductEntity>> asyncValue = ref.watch(provider);
    final PaginationAsyncNotifier? notifier =
        enablePagination && notifierProvider != null
            ? ref.read(notifierProvider!)
            : null;
    final ScrollController scrollController = useScrollController();

    // Load more on scroll (only if pagination is enabled)
    useEffect(() {
      if (!enablePagination || notifier == null) return null;

      void onScroll() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 100 &&
            scrollController.position.userScrollDirection ==
                ScrollDirection.reverse) {
          notifier.loadMore();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, <Object?>[scrollController, enablePagination]);

    // Snackbar for loadMore error (only if pagination is enabled)
    useEffect(() {
      if (!enablePagination || notifier == null) return null;

      if (notifier.loadMoreError != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          openStyledSnackBar(
            context,
            text: 'Failed to load more: ${notifier.loadMoreError}',
            type: SnackBarType.error,
          );
        });
      }
      return null;
    }, <Object?>[notifier?.loadMoreError]);

    return RefreshIndicator(
      onRefresh: () async => notifier?.refresh(),
      child: Column(
        children: <Widget>[
          if (enablePagination && notifier != null)
            Material(
              elevation: 2,
              color: context.color.surface,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: HorizontalFilterSortDisplay(notifier),
              ),
            ),
          Expanded(
            child: asyncValue.when(
              loading:
                  () =>
                      ref.watch(isGridViewModeProvider)
                          ? const SeeAllGridViewShimmer()
                          : const SeeAllListViewShimmer(),
              error:
                  (Object e, _) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Error: $e',
                            style: AppStyles.font16PrimarySemiBold(context),
                          ),
                          const SizedBox(height: 12),
                          if (notifier != null)
                            ElevatedButton(
                              onPressed: notifier.refresh,
                              child: const Text(AppStrings.kRetry),
                            ),
                        ],
                      ),
                    ),
                  ),
              data: (List<ProductEntity> products) {
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.kNoProductsFound,
                      style: AppStyles.font18PrimarySemiBold(context),
                    ),
                  );
                }

                final bool isGrid = ref.watch(isGridViewModeProvider);
                final bool isLoadingMore =
                    enablePagination && notifier != null
                        ? notifier.isLoading
                        : false;

                return Column(
                  children: <Widget>[
                    Expanded(
                      child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 350),
                        reverse:
                            !isGrid, // optional: flips direction when toggling back
                        transitionBuilder:
                            (child, animation, secondaryAnimation) =>
                                SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType
                                          .scaled, // or .horizontal / .vertical
                                  child: child,
                                ),
                        child:
                            isGrid
                                ? SeeAllGridView(
                                  key: const ValueKey('grid'),
                                  data: products,
                                  controller: scrollController,
                                  favoriteIcon: false,
                                )
                                : SeeAllListView(
                                  key: const ValueKey('list'),
                                  data: products,
                                  controller: scrollController,
                                ),
                      ),
                    ),
                    if (isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: StyledLoading(size: 30),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

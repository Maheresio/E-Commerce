import 'package:e_commerce/core/responsive/responsive_value.dart';
import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../shop/presentation/controller/filter_models.dart';
import '../../../shop/presentation/controller/pagination_async_notifier.dart';
import '../../../shop/presentation/controller/shop_fetch_functions.dart';
import '../../../shop/presentation/controller/shop_pagination_providers.dart';
import '../controller/product_provider.dart';
import '../widgets/see_all_view_body.dart';

class SeeAllView extends ConsumerWidget {
  const SeeAllView({
    super.key,
    required this.provider,
    this.notifierProvider,
    this.enablePagination = true,
    this.isSearchResults = false,
  });

  /// 1. Filtered products
  factory SeeAllView.filtered(WidgetRef ref) {
    final fetchFn = getFilteredProductsFetch(ref);
    final provider = filteredProductsProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  /// 2. All products
  factory SeeAllView.all(WidgetRef ref) {
    final fetchFn = getAllProductsFetch(ref);
    final provider = allProductsProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  // Sale Products
  factory SeeAllView.sale(WidgetRef ref) {
    final fetchFn = getSaleProductsFetch(ref);
    final provider = saleProductsProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  /// 3. By gender
  factory SeeAllView.byGender(WidgetRef ref, String gender) {
    final fetchFn = getProductsByGenderFetch(ref, gender);
    final provider = productsByGenderProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  /// 4. By gender + subCategory
  factory SeeAllView.byGenderAndSub(
    WidgetRef ref,
    String gender,
    String subCategory,
  ) {
    final fetchFn = getProductsByGenderAndSubFetch(
      ref,
      (ProductsByGenderAndSubParams(gender: gender, subCategory: subCategory)),
    );
    final provider = productsByGenderAndSubProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  /// 5. Newest by gender
  factory SeeAllView.newestByGender(WidgetRef ref, String gender) {
    final fetchFn = getNewestByGenderFetch(ref, gender);
    final provider = newestByGenderProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  /// 6. Search by tags
  factory SeeAllView.searchByTags(WidgetRef ref, List<String> tags) {
    final fetchFn = getSearchByTagsFetch(ref, tags);
    final provider = searchPaginationProvider(fetchFn);
    return SeeAllView(provider: provider, notifierProvider: provider.notifier);
  }

  /// 7. Search results (static data)
  factory SeeAllView.searchResults(List<ProductEntity> products) {
    // Create a provider that returns the static products
    final staticProvider = Provider<AsyncValue<List<ProductEntity>>>((ref) {
      return AsyncValue.data(products);
    });

    return SeeAllView(
      provider: staticProvider,
      enablePagination: false,
      isSearchResults: true,
    );
  }
  final ProviderListenable<AsyncValue<List<ProductEntity>>> provider;
  final ProviderListenable<PaginationAsyncNotifier>? notifierProvider;
  final bool enablePagination;
  final bool isSearchResults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isSearchResults) {
      // Custom app bar for search results
      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          scrolledUnderElevation: 0,
          titleTextStyle: AppStyles.font18BlackSemiBold(context),
          toolbarHeight: context.responsive(mobile: 65.h, tablet: 90.h),
          title: Text(
            AppStrings.kSearchResults,
            style: AppStyles.font18BlackSemiBold(context),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
          actions: <Widget>[
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final bool isGrid = ref.watch(isGridViewModeProvider);
                return IconButton(
                  icon: Icon(
                    isGrid ? Icons.list_outlined : Icons.grid_view_outlined,
                  ),
                  onPressed: () {
                    ref.read(isGridViewModeProvider.notifier).toggle();
                  },
                  tooltip:
                      isGrid
                          ? AppStrings.kSwitchToListView
                          : AppStrings.kSwitchToGridView,
                );
              },
            ),
          ],
        ),
        body: SeeAllViewBody(
          provider: provider,
          notifierProvider: notifierProvider,
          enablePagination: enablePagination,
        ),
      );
    }

    // Original app bar for other views
    final FilterParams params = ref.watch(filterParamsProvider);
    return Scaffold(
      appBar: styledAppBar(
        onTap: () {
          ref
              .read(filterParamsProvider.notifier)
              .update((FilterParams param) => param.copyWith(subCategory: ''));
        },
        context,
        title:
            "${params.gender.isNotEmpty ? params.gender[0].toUpperCase() + params.gender.substring(1) : params.gender}'s ${params.subCategory.isNotEmpty ? params.subCategory[0].toUpperCase() + params.subCategory.substring(1) : params.subCategory}",
      ),
      body: SeeAllViewBody(
        provider: provider,
        notifierProvider: notifierProvider,
        enablePagination: enablePagination,
      ),
    );
  }
}

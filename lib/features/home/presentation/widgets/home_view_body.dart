import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../shop/presentation/controller/filter_models.dart';
import '../controller/home_provider.dart';
import 'home_banner.dart';
import 'home_horizontal_list_view_section.dart';

class HomeViewBody extends ConsumerWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
    child: Column(
      children: [
        const HomeBanner(),
        const SizedBox(height: 30),

        Column(
          children: [
            HomeHorizontalListViewSection(
              title: AppStrings.kSale,
              subtitle: AppStrings.kSuperSummerSale,

              onSeeAll: () {
                ref
                    .read(filterParamsProvider.notifier)
                    .update((state) => state.copyWith(gender: 'all'));
                context.push(AppRoutes.seeAll, extra: {'type': 'sale'});
              },
              productProvider: saleProductsProvider,
            ),

            HomeHorizontalListViewSection(
              title: AppStrings.kNew,
              subtitle: AppStrings.kNeverSeenBefore,
              onSeeAll: () {
                ref
                    .read(filterParamsProvider.notifier)
                    .update((state) => state.copyWith(gender: 'all'));
                context.push(AppRoutes.seeAll, extra: {'type': 'all'});
              },
              productProvider: newProductsProvider,
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    ),
  );
}

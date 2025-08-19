import 'package:e_commerce/core/routing/app_route_constants.dart';
import 'package:e_commerce/features/checkout/presentation/controller/visa_card/visa_card_providers.dart';
import 'package:e_commerce/features/favorite/presentation/widgets/favorite_shimmer.dart';

import '../../../../core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/text_header.dart';

import '../controller/favorite_controller.dart';
import 'favorite_list_item.dart';

class FavoriteViewBody extends StatelessWidget {
  const FavoriteViewBody({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              const TextHeader(title: AppStrings.kFavorites),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final userId = ref.read(currentUserServiceProvider).currentUserId;
            final favoritesProvider = ref.watch(
              favoritesControllerProvider(userId!),
            );

            return favoritesProvider.when(
              data: (data) {
                if (data.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        AppStrings.kNoFavoritesYet,
                        style: AppStyles.font18PrimarySemiBold(context),
                      ),
                    ),
                  );
                }

                return SliverList.builder(
                  itemBuilder:
                      (context, index) => GestureDetector(
                        onTap: () {
                          context.push(
                            AppRoutes.productDetails,
                            extra: data[index],
                          );
                        },
                        child: FavoriteListItem(data[index]),
                      ),

                  itemCount: data.length,
                );
              },
              error:
                  (error, stackTrace) => SliverFillRemaining(
                    child: Center(
                      child: Text(
                        error.toString(),
                        style: AppStyles.font14BlackRegular(context),
                      ),
                    ),
                  ),
              loading: () => const FavoriteListShimmer(),
            );
          },
        ),
      ],
    ),
  );
}

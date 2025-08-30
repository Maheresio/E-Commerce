import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/responsive/responsive_value.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/product_entity.dart';
import 'home_list_view_header.dart';
import 'home_list_view_item.dart';
import 'home_shimmer.dart';

class HomeHorizontalListViewSection extends StatelessWidget {
  const HomeHorizontalListViewSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onSeeAll,
    required this.productProvider,
  });

  final String title;
  final String subtitle;
  final VoidCallback onSeeAll;
  final StreamProvider<List<ProductEntity>> productProvider;
  @override
  Widget build(BuildContext context) => Column(
    spacing: 6,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding16,
        ),
        child: HomeListViewHeader(
          title: title,
          subtitle: subtitle,
          onSeeAll: onSeeAll,
        ),
      ),
      SizedBox(
        height: context.responsive(mobile: 320.h, tablet: 480.h),
        child: Consumer(
          builder: (context, ref, child) {
            return ref
                .watch(productProvider)
                .when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.kNoProductsFound,
                          style: AppStyles.font18PrimarySemiBold(context),
                        ),
                      );
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final item = HomeListViewItem(data[index]);

                        // Add left padding only to the first item
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: AppConstants.horizontalPadding16,
                            ),
                            child: item,
                          );
                        }
                        if (index == data.length - 1) {
                          // Add right padding only to the last item
                          return Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: AppConstants.horizontalPadding16,
                            ),
                            child: item,
                          );
                        }

                        return item;
                      },
                      separatorBuilder: (_, _) => SizedBox(width: 0.w),
                      itemCount: data.length,
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        error is Failure
                            ? Failure(error.message).message
                            : error.toString(),
                        style: AppStyles.font16BlackRegular(context),
                      ),
                    );
                  },
                  loading: () => const HomeHorizontalListViewShimmer(),
                );
          },
        ),
      ),
    ],
  );
}

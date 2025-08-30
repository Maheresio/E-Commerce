import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../controller/filter_models.dart';

class CategoryViewBody extends StatelessWidget {
  const CategoryViewBody({
    super.key,
    required this.genderList,
    required this.index,
  });

  final Map<String, dynamic> genderList;
  final int index;
  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> subCategoriesList =
        genderList['subCategories'] as Map<String, List<String>>;
    final List<String> categoryList = subCategoriesList.keys.toList();

    final String selectedCategory =
        categoryList[index - 1]; // Assuming index starts from 1 for categories
    final List<String> selectedSubcategories =
        subCategoriesList[selectedCategory]!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8.h),
          Consumer(
            builder:
                (BuildContext context, WidgetRef ref, _) =>
                    CircularElevatedButton(
                      text: AppStrings.kViewAllItems.toUpperCase(),
                      onPressed: () {
                        context.push(
                          AppRoutes.seeAll,
                          extra: <String, String>{
                            'type': 'byGender',
                            'gender':
                                ref
                                    .read(filterParamsProvider.notifier)
                                    .state
                                    .gender,
                          },
                        );
                      },
                    ),
          ),

          Expanded(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppStrings.kChooseCategory,
                  style: AppStyles.font14GreyMedium(context),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder:
                        (BuildContext context, int i) => Consumer(
                          builder: (context, ref, child) {
                            return ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,

                              title: Text(
                                selectedSubcategories[i],
                                style: AppStyles.font14BlackMedium(context),
                              ),

                              onTap: () {
                                ref
                                    .read(filterParamsProvider.notifier)
                                    .update(
                                      (param) => param.copyWith(
                                        subCategory: selectedSubcategories[i],
                                      ),
                                    );
                                context.push(
                                  AppRoutes.seeAll,
                                  extra: {
                                    'type': 'byGenderAndSub',
                                    'gender':
                                        ref
                                            .read(filterParamsProvider.notifier)
                                            .state
                                            .gender,
                                    'subCategory': selectedSubcategories[i],
                                  },
                                );
                              },
                            );
                          },
                        ),
                    separatorBuilder:
                        (BuildContext context, int index) => Divider(
                          color: context.color.secondary.withValues(alpha: 0.1),
                        ),
                    itemCount: selectedSubcategories.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

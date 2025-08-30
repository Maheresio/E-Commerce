import '../../../../core/routing/app_route_constants.dart';

import '../controller/filter_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';
import 'shop_summer_sales.dart';

class GenderTabView extends ConsumerWidget {
  const GenderTabView(this.genderList, {super.key});

  final Map<String, dynamic> genderList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = genderList['categories'];
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        children: <Widget>[
          const ShopSummerSales(),

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder:
                (BuildContext context, int index) => InkWell(
                  onTap: () {
                    if (index == 0) {
                      context.push(
                        AppRoutes.seeAll,
                        extra: <String, String>{
                          'type': 'newestByGender',
                          'gender':
                              ref
                                  .read(filterParamsProvider.notifier)
                                  .state
                                  .gender,
                        },
                      );
                    } else {
                      context.push(
                        AppRoutes.category,
                        extra: (genderList, index),
                      );
                    }
                  },
                  child: Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: context.color.onSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(start: 20.w),
                            child: Text(
                              categoryList.keys.elementAt(index),
                              style: AppStyles.font18BlackSemiBold(context),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadiusDirectional.only(
                              topEnd: Radius.circular(8),
                              bottomEnd: Radius.circular(8),
                            ),
                            child: SizedBox(
                              height: double.infinity,
                              child: Image.asset(
                                categoryList.values.elementAt(index),

                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            separatorBuilder:
                (BuildContext context, int index) => const SizedBox(height: 16),
            itemCount: categoryList.length,
          ),
        ],
      ),
    );
  }
}

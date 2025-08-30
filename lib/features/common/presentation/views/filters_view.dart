import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import '../../../shop/presentation/controller/filter_models.dart';
import '../widgets/filters_view_body.dart';

class FiltersView extends StatelessWidget {
  const FiltersView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        height: 104.h,
        child: Row(
          spacing: 23.w,
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return CircularElevatedButton(
                    color: context.color.onSecondary,
                    borderColor: context.color.onPrimary,
                    textColor: context.color.onPrimary,
                    text: AppStrings.kDiscard,

                    onPressed: () {
                      ref.read(tempFilterParamsProvider.notifier).state = ref
                          .read(filterParamsProvider);
                      context.pop();
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  return CircularElevatedButton(
                    text: AppStrings.kApply,
                    onPressed: () {
                      final temp = ref.read(tempFilterParamsProvider);
                      ref.read(filterParamsProvider.notifier).state = temp;
                      context.push(
                        AppRoutes.seeAll,
                        extra: {'type': 'filtered'},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    appBar: styledAppBar(context, title: AppStrings.kFilters),
    body: const FiltersViewBody(),
  );
}

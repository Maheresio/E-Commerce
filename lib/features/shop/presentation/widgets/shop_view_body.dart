import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global/themes/light/app_colors_light.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/helpers/methods/product_lists.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../controller/filter_models.dart';
import 'gender_tab_view.dart';

class ShopViewBody extends StatefulWidget {
  const ShopViewBody({super.key});

  @override
  State<ShopViewBody> createState() => _ShopViewBodyState();
}

class _ShopViewBodyState extends State<ShopViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? womenCategoryList =
        categoryData[AppStrings.kGenderWomenCapitalized];
    final Map<String, dynamic>? menCategoryList =
        categoryData[AppStrings.kGenderMenCapitalized];
    final Map<String, dynamic>? kidsCategoryList =
        categoryData[AppStrings.kGenderKidsCapitalized];

    return Column(
      children: <Widget>[
        Consumer(
          builder:
              (BuildContext context, WidgetRef ref, Widget? child) =>
                  ColoredBox(
                    color: Colors.white,
                    child: TabBar(
                      onTap: (value) {
                        ref
                            .read(filterParamsProvider.notifier)
                            .update(
                              (param) => param.copyWith(
                                gender: _genderValueAdapter(value),
                              ),
                            );
                      },
                      controller: _tabController,
                      labelColor: AppColorsLight.kBlack,
                      unselectedLabelColor: AppColorsLight.kGrey,
                      labelStyle: AppStyles.font16BlackSemiBold(context),
                      unselectedLabelStyle: AppStyles.font14GreyRegular(
                        context,
                      ),
                      indicatorColor: context.color.primary,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: AppStrings.kGenderWomenCapitalized),
                        Tab(text: AppStrings.kGenderMenCapitalized),
                        Tab(text: AppStrings.kGenderKidsCapitalized),
                      ],
                    ),
                  ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                GenderTabView(womenCategoryList!),
                GenderTabView(menCategoryList!),
                GenderTabView(kidsCategoryList!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _genderValueAdapter(int index) => switch (index) {
    0 => AppStrings.kGenderWomen,
    1 => AppStrings.kGenderMen,
    2 => AppStrings.kGenderKids,
    _ => AppStrings.kGenderWomen,
  };
}

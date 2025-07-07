import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../controller/home_provider.dart';
import 'home_banner.dart';
import 'home_horizontal_list_view_section.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeBanner(),
          SizedBox(height: 30),

          Column(
            children: [
              HomeHorizontalListViewSection(
                title: AppStrings.kSale,
                subtitle: AppStrings.kSuperSummerSale,
                onSeeAll: () {},
                productProvider: saleProductsProvider,
              ),

              HomeHorizontalListViewSection(
                title: AppStrings.kNew,
                subtitle: AppStrings.kNeverSeenBefore,
                onSeeAll: () {},
                productProvider: newProductsProvider,
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

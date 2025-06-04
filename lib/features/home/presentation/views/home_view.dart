import 'package:e_commerce/core/global/themes/light/app_colors_light.dart';
import 'package:e_commerce/core/routing/app_router.dart';
import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: AppStrings.kVisualSearch,
        onPressed: () {
          context.push(AppRouter.kSearchView);
        },
        child: const Icon(
          Icons.image_search_outlined,
          color: AppColorsLight.kwhite,
        ),
      ),
      body: HomeViewBody(),
    );
  }
}

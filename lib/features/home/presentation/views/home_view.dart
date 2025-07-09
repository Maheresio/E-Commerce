import 'package:e_commerce/core/helpers/extensions/context_extensions.dart';
import 'package:e_commerce/core/responsive/responsive_value.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: context.responsive(
        mobile: FloatingActionButton(
          foregroundColor: context.color.onSecondary,
          tooltip: AppStrings.kVisualSearch,
          onPressed: () => context.push(AppRouter.kSearchView),
          child: const Icon(Icons.image_search_outlined),
        ),
        tablet: FloatingActionButton.large(
          foregroundColor: context.color.onSecondary,
          tooltip: AppStrings.kVisualSearch,
          onPressed: () => context.push(AppRouter.kSearchView),
          child: const Icon(Icons.image_search_outlined),
        ),
      ),
      body: HomeViewBody(),
    );
  }
}

import 'package:e_commerce/core/routing/app_route_constants.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/responsive/responsive_value.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_strings.dart';
import '../widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: context.responsive(
      mobile: FloatingActionButton(
        foregroundColor: context.color.onSecondary,
        tooltip: AppStrings.kVisualSearch,
        onPressed: () => context.push(AppRoutes.search),
        child: const Icon(Icons.lens_blur),
      ),
      tablet: FloatingActionButton.large(
        foregroundColor: context.color.onSecondary,
        tooltip: AppStrings.kVisualSearch,
        onPressed: () => context.push(AppRoutes.search),
        child: const Icon(Icons.lens_blur),
      ),
    ),
    body: const HomeViewBody(),
  );
}

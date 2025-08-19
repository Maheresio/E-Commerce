import 'package:flutter/material.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import '../widgets/search_view_body.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    _cacheImages(context);
    return Scaffold(
      appBar: styledAppBar(context, title: AppStrings.kVisualSearch),
      body: const SearchViewBody(),
    );
  }

  Future<void> _cacheImages(BuildContext context) =>
      precacheImage(const AssetImage(AppImages.searchBackground), context);
}

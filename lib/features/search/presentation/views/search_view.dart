import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:e_commerce/features/checkout/presentation/widgets/checkout_app_bar.dart';
import 'package:e_commerce/features/search/presentation/widgets/search_view_body.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkoutAppBar(context, AppStrings.kVisualSearch),
      body: SearchViewBody(),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../checkout/presentation/widgets/checkout_app_bar.dart';
import '../widgets/search_view_body.dart';

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

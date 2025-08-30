import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import '../widgets/shop_view_body.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: styledAppBar(
        context,
        title: AppStrings.kCategories,
        automaticallyImplyLeading: false,
      ),
      body: const ShopViewBody(),
    );
  }
}

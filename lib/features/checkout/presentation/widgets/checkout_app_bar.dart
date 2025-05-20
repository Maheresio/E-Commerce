import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';

AppBar checkoutAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    titleTextStyle: AppStyles.font18BlackSemiBold,
    centerTitle: true,
    surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
    elevation: 6,
    shadowColor: Colors.white,
    scrolledUnderElevation: 1, 
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
      onPressed: () => context.pop(),
    ),
  );
}

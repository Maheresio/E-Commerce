import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_strings.dart';
import 'my_orders_back_navigation.dart';
import 'my_orders_header_text.dart';
import 'my_orders_status_tab_bars.dart';
import 'my_orders_list_view.dart';

class MyOrdersViewBody extends StatelessWidget {
  const MyOrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final orderTabs = <String>[
      AppStrings.kDelivered,
      AppStrings.kProcessing,
      AppStrings.kCancelled,
    ];
    final double horizontalPadding = 16.w;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 40),
        MyOrdersBackNavigation(horizontalPadding: horizontalPadding),
        const SizedBox(height: 30),
        MyOrdersHeaderText(horizontalPadding: horizontalPadding),
        const SizedBox(height: 20),
        MyOrdersStatusTabBars(
          horizontalPadding: horizontalPadding,
          orderTabs: orderTabs,
        ),
        const SizedBox(height: 30),
        MyOrdersListView(horizontalPadding: horizontalPadding),
      ],
    );
  }
}

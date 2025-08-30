import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../../../checkout/presentation/widgets/styled_app_bar.dart';
import '../widgets/order_details_view_body.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView(this.order, {super.key});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: styledAppBar(context, title: AppStrings.kOrderDetails),
    body: OrderDetailsViewBody(order),
  );
}

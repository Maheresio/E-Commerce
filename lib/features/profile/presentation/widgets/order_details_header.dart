import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/helpers/methods/date_time_parser.dart';
import '../../../checkout/domain/entities/order_entity.dart';

class OrderDetailsHeader extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailsHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.kOrderCodeFormat.replaceAll('%s', order.id),
              style: AppStyles.font16BlackSemiBold(context),
            ),
            Text(
              parseDateTime(order.date),
              style: AppStyles.font14GreyRegular(context),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${AppStrings.kTrackingNumber}:  ',
                    style: AppStyles.font14GreyRegular(context),
                  ),
                  TextSpan(
                    text: order.trackingNumber,
                    style: AppStyles.font14BlackMedium(context),
                  ),
                ],
              ),
              style: AppStyles.font14GreyRegular(context),
            ),
            Text(
              order.status.name.replaceFirst(
                order.status.name[0],
                order.status.name[0].toUpperCase(),
              ),
              style: AppStyles.font14GreenMedium(context),
            ),
          ],
        ),
      ],
    );
  }
}

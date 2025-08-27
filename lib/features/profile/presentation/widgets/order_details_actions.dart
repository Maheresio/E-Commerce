import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/circular_elevated_button.dart';

class OrderDetailsActions extends StatelessWidget {
  const OrderDetailsActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 24.w,
      children: [
        Expanded(
          child: CircularElevatedButton(
            text: AppStrings.kReorder,
            onPressed: () {},
          ),
        ),
        const Expanded(
          child: CircularElevatedButton(text: AppStrings.kLeaveFeedback),
        ),
      ],
    );
  }
}

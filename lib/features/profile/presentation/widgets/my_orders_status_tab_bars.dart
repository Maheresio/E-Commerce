import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';

class MyOrdersStatusTabBars extends StatelessWidget {
  final double horizontalPadding;
  final List<String> orderTabs;
  const MyOrdersStatusTabBars({
    super.key,
    required this.horizontalPadding,
    required this.orderTabs,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        SizedBox(width: horizontalPadding),
        Row(
          children: List.generate(
            orderTabs.length,
            (index) => Padding(
              padding: EdgeInsets.only(right: 7.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(30.r),
                onTap: () {},
                child: Container(
                  width: 110.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color:
                        index == 0
                            ? context.color.primaryFixed
                            : context.color.surface,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      orderTabs[index],
                      style:
                          index == 0
                              ? AppStyles.font14WhiteMedium(context)
                              : AppStyles.font14BlackMedium(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

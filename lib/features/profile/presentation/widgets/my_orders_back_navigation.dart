import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MyOrdersBackNavigation extends StatelessWidget {
  final double horizontalPadding;
  const MyOrdersBackNavigation({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.only(start: horizontalPadding),
    child: InkWell(
      onTap: () => context.pop(),
      child: Icon(Icons.arrow_back_ios_new, size: 24.sp),
    ),
  );
}

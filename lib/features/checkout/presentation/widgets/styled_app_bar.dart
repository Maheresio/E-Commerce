import '../../../../core/responsive/responsive_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';

AppBar styledAppBar(
  BuildContext context, {
  required String title,
  IconData? icon,
  Function()? onTap,
  automaticallyImplyLeading = true,
}) => AppBar(
    toolbarHeight: context.responsive(mobile: 65.h, tablet: 90.h),
    title: Text(title),
    titleTextStyle: AppStyles.font18BlackSemiBold(context),
    centerTitle: true,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.white,
    shadowColor: Colors.transparent,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: automaticallyImplyLeading,
    leading:
        automaticallyImplyLeading
            ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: context.responsive(mobile: 25, tablet: 40),
              ),
              onPressed: () {
                onTap?.call();
                context.pop();
              },
            )
            : null,
    actions: [
      IconButton(
        icon: Icon(icon, size: context.responsive(mobile: 25, tablet: 40)),
        onPressed: () {},
      ),
    ],
  );

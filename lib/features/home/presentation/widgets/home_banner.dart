import 'package:e_commerce/core/responsive/responsive_value.dart';
import 'package:e_commerce/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveValue(mobile: 196.h, tablet: 280.h),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.homeBanner),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppConstants.horizontalPadding16,
            bottom: 10,
          ),
          child: Text(
            AppStrings.kStreetClothes,
            style: AppStyles.font34WhiteBlack(context),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
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
          padding: const EdgeInsetsDirectional.only(start: 16, bottom: 10),
          child: Text(
            AppStrings.kStreetClothes,
            style: AppStyles.font34WhiteBlack,
          ),
        ),
      ),
    );
  }
}

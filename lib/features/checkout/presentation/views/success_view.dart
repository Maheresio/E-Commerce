import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SizedBox(
          height: 1.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: .3.sh),
                  SvgPicture.asset(AppImages.bags),
                  const SizedBox(height: 49),
                  Text(
                    AppStrings.kSuccess,
                    style: AppStyles.font34BlackBold(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    textAlign: TextAlign.center,
                    AppStrings.kOrderDeliveryMessage,
                    style: AppStyles.font14GreyRegular(context),
                  ),
                ],
              ),
              // Spacer(),
              Column(
                children: [
                  CircularElevatedButton(
                    text: AppStrings.kContinueShopping,
                    onPressed: () => context.go(AppRouter.kNavBar),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

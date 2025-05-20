import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/styled_text_form_field.dart';
import 'shipping_check_box.dart';

class AddVisaCardBottomSheet extends StatelessWidget {
  const AddVisaCardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        bottom: MediaQuery.of(context).viewInsets.bottom * .7 + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: [
            Text(AppStrings.kAddNewCard, style: AppStyles.font18BlackSemiBold),

            StyledTextFormField(
              text: AppStrings.kNameOnCard,
              controller: TextEditingController(),
            ),
            StyledTextFormField(
              text: AppStrings.kCardNumber,
              controller: TextEditingController(),
              suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: SvgPicture.asset(AppImages.mastercard),
              ),
            ),
            StyledTextFormField(
              text: AppStrings.kExpireDate,
              controller: TextEditingController(),
            ),
            StyledTextFormField(
              text: AppStrings.kSecurityCodeHint,
              controller: TextEditingController(),
              textInputAction: TextInputAction.done,
            ),

            ShippingCheckbox(text: AppStrings.kUseAsDefaultPaymentMethod),

            ElevatedButton(onPressed: () {}, child: Text(AppStrings.kAddCard)),
          ],
        ),
      ),
    );
  }
}

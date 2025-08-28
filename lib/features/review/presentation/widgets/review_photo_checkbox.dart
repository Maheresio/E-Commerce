import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

/// Checkbox widget for filtering reviews with photos
class ReviewPhotoCheckbox extends StatefulWidget {
  const ReviewPhotoCheckbox({super.key});

  @override
  State<ReviewPhotoCheckbox> createState() => _ReviewPhotoCheckboxState();
}

class _ReviewPhotoCheckboxState extends State<ReviewPhotoCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Transform.scale(
        scale: 1.2,
        child: Checkbox.adaptive(
          activeColor: context.color.primaryFixed,
          checkColor: context.color.onSecondary,
          value: isChecked,
          onChanged: (val) {
            setState(() {
              isChecked = !isChecked;
            });
          },
          side: BorderSide(color: context.color.onPrimary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
            side: BorderSide(color: context.color.onPrimary),
          ),
        ),
      ),
      Text(AppStrings.kWithPhoto, style: AppStyles.font14BlackMedium(context)),
    ],
  );
}

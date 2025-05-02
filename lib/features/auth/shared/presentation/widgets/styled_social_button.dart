import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/helpers/extensions/theme_color.extension.dart';

class StyledSocialButton extends StatelessWidget {
  const StyledSocialButton({super.key, required this.image, this.onTap});

  final String image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      width: 100.w,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: .5,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          splashColor: context.color.primary.withValues(alpha: 0.1),
          child: Center(child: SvgPicture.asset(image)),
        ),
      ),
    );
  }
}

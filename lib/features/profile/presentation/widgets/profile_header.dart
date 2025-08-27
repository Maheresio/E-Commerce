import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final String? email;
  const ProfileHeader({super.key, this.photoUrl, this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage:
              photoUrl != null
                  ? NetworkImage(photoUrl!)
                  : const AssetImage(AppImages.userAvatar) as ImageProvider,
          radius: 35.r,
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name ?? AppStrings.kDefaultUserName,
              style: AppStyles.font18BlackSemiBold(context),
            ),
            Text(
              email ?? AppStrings.kDefaultUserEmail,
              style: AppStyles.font14GreyMedium(context),
            ),
          ],
        ),
      ],
    );
  }
}

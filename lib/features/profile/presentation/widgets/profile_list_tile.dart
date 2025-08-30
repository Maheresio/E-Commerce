import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_styles.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final double padding;
  const ProfileListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: padding),
      title: Text(title, style: AppStyles.font16BlackSemiBold(context)),
      subtitle: Text(subtitle, style: AppStyles.font12GreyMedium(context)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: Colors.grey.shade600,
      ),
    );
  }
}

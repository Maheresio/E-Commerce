import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;
  const ProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppStyles.font34BlackBold(context));
  }
}

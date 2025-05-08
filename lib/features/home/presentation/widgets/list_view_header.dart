import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class ListViewHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onPressed;
  const ListViewHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppStyles.font34BlackBold.copyWith(height: 1)),
      subtitle: Text(subtitle, style: AppStyles.font14GreyRegular),
      trailing: TextButton(
        onPressed: onPressed,
        child: Text(AppStrings.kViewAll, style: AppStyles.font14BlackRegular),
      ),
    );
  }
}

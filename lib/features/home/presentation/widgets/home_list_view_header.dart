import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class HomeListViewHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onSeeAll;
  const HomeListViewHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppStyles.font34BlackBold(context).copyWith(height: 1),
      ),
      subtitle: Text(subtitle, style: AppStyles.font14GreyRegular(context)),
      trailing: InkWell(
        onTap: onSeeAll,
        child: Text(
          AppStrings.kViewAll,
          style: AppStyles.font12BlackMedium(context),
        ),
      ),
    );
  }
}

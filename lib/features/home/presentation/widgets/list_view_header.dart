import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class ListViewHeader extends StatelessWidget {
  const ListViewHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        AppStrings.kSale,
        style: AppStyles.font34BlackBold.copyWith(height: 1),
      ),
      subtitle: Text(
        AppStrings.kSuperSummerSale,
        style: AppStyles.font14GreyRegular,
      ),
      trailing: TextButton(
        onPressed: () {},
        child: Text(
          AppStrings.kViewAll,
          style: AppStyles.font14BlackRegular,
        ),
      ),
    );
  }
}

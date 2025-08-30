import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

/// Header widget for the review view with back button and title
class ReviewViewHeader extends StatelessWidget {
  const ReviewViewHeader({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      GestureDetector(
        onTap: () => context.pop(),
        child: Icon(Icons.arrow_back_ios_new, color: context.color.onPrimary),
      ),
      const SizedBox(height: 20),
      Text(
        AppStrings.kRatingAndReviews,
        style: AppStyles.font34BlackBold(context),
      ),
      const SizedBox(height: 30),
    ],
  );
}

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/review_entity.dart';

class ReviewActionButtons extends StatelessWidget {
  const ReviewActionButtons({
    super.key,
    required this.currentUserReview,
    required this.onSubmit,
    required this.onDelete,
  });

  final ReviewEntity? currentUserReview;
  final VoidCallback onSubmit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (currentUserReview != null)
        Expanded(
          child: OutlinedButton(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text(AppStrings.kDeleteReview),
          ),
        ),
      if (currentUserReview != null) SizedBox(width: 16.w),
      Expanded(
        flex: 2,
        child: CircularElevatedButton(
          text:
              currentUserReview != null
                  ? AppStrings.kUpdateReview
                  : AppStrings.kSendReview,
          onPressed: onSubmit,
        ),
      ),
    ],
  );
}

import '../../../../core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/helpers/methods/date_time_parser.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

import '../../domain/entities/review_entity.dart';

/// Widget to display a single review item
class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({
    super.key,
    required this.review,
    required this.productRating,
    this.onHelpfulPressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.isUserLoggedIn = false,
    this.isUserReview = false,
  });

  final ReviewEntity review;
  final double productRating;
  final VoidCallback? onHelpfulPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final bool isUserLoggedIn;
  final bool isUserReview;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: context.color.tertiary.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            color: context.color.onSecondary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name
                Text(
                  review.userName,
                  style: AppStyles.font14BlackSemiBold(context),
                ),
                const SizedBox(height: 2),

                // Rating and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StarRatingWidget(rating: review.rating.toInt()),
                    Text(
                      parseDateTime(review.createdAt),
                      style: AppStyles.font11GreyMedium(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Review content
                Text(
                  review.content,
                  style: AppStyles.font13BlackMedium(context),
                ),

                // Review images (if any)
                if (review.reviewImagesUrls != null &&
                    review.reviewImagesUrls!.isNotEmpty)
                  ReviewImagesWidget(imageUrls: review.reviewImagesUrls!),

                // Action buttons for user's own review or helpful section
                if (isUserReview &&
                    (onEditPressed != null || onDeletePressed != null))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Edit and Delete buttons for user's review
                      Row(
                        children: [
                          if (onEditPressed != null)
                            TextButton.icon(
                              onPressed: onEditPressed,
                              icon: Icon(Icons.edit, size: 16.w),
                              label: const Text(AppStrings.kEdit),
                              style: TextButton.styleFrom(
                                foregroundColor: context.color.tertiary,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                              ),
                            ),
                          if (onDeletePressed != null)
                            TextButton.icon(
                              onPressed: onDeletePressed,
                              icon: Icon(Icons.delete, size: 16.w),
                              label: const Text(AppStrings.kDelete),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                              ),
                            ),
                        ],
                      ),
                      // Helpful section
                      HelpfulSectionWidget(
                        helpfulCount: review.helpfulCount,
                        onPressed: isUserLoggedIn ? onHelpfulPressed : null,
                      ),
                    ],
                  )
                else
                  // Just helpful section for other reviews
                  Align(
                    alignment: Alignment.centerRight,
                    child: HelpfulSectionWidget(
                      helpfulCount: review.helpfulCount,
                      onPressed: isUserLoggedIn ? onHelpfulPressed : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // User avatar
      UserAvatarWidget(userImageUrl: review.userImageUrl),
    ],
  );
}

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(
      5,
      (i) => Icon(
        Icons.star,
        color: i < rating ? context.color.tertiary : Colors.black12,
        size: 15.w,
      ),
    ),
  );
}

class ReviewImagesWidget extends StatelessWidget {
  const ReviewImagesWidget({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 112.h,
        child: Row(
          children: List.generate(
            imageUrls.length,
            (i) => AspectRatio(
              aspectRatio: 1.1,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(imageUrls[i], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class HelpfulSectionWidget extends StatelessWidget {
  const HelpfulSectionWidget({
    super.key,
    required this.helpfulCount,
    this.onPressed,
  });

  final int helpfulCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
            onPressed != null
                ? context.color.secondary.withValues(alpha: 0.1)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: 8.w,
        children: [
          Text(
            '$helpfulCount ${AppStrings.kHelpful}',
            style: AppStyles.font11GreyMedium(context),
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.thumb_up,
            size: 16.w,
            color:
                onPressed != null
                    ? context.color.tertiary
                    : context.color.secondary,
          ),
        ],
      ),
    ),
  );
}

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({super.key, required this.userImageUrl});

  final String? userImageUrl;

  @override
  Widget build(BuildContext context) => PositionedDirectional(
    top: 4.h,
    start: 8.w,
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: 12.r,
      backgroundImage: const AssetImage(AppImages.userAvatar),
    ),
  );
}

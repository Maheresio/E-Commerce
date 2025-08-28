import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewRatingBar extends StatelessWidget {
  const ReviewRatingBar({
    super.key,
    required this.initialRating,
    required this.onRatingUpdate,
  });

  final double initialRating;
  final ValueChanged<double> onRatingUpdate;

  @override
  Widget build(BuildContext context) => RatingBar.builder(
    initialRating: initialRating,
    minRating: 1,
    unratedColor: context.color.secondary.withValues(alpha: 0.15),
    direction: Axis.horizontal,
    allowHalfRating: true,
    glow: false,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
    itemBuilder:
        (context, _) => Icon(Icons.star, color: context.color.tertiary),
    onRatingUpdate: onRatingUpdate,
  );
}

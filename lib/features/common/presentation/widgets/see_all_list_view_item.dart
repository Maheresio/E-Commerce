import 'package:e_commerce/core/widgets/cached_image_widget.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/presentation/widgets/home_list_view_item.dart';

class SeeAllListViewItem extends StatelessWidget {
  const SeeAllListViewItem({super.key, required this.data});

  final ProductEntity data;

  @override
  Widget build(BuildContext context) {
     final themeColors = context.color;
    return GestureDetector(
    onTap: () => context.push(AppRouter.kProductDetails, extra: data),
    child: Container(
      height: 130.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: themeColors.onPrimary.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        color: themeColors.onSecondary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8.r),
                bottomStart: Radius.circular(8.r),
              ),
              child: CachedImageWidget(
                imgUrl: data.imageUrls.entries.first.value.first,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    maxLines: 2,
                    data.name,
                    style: AppStyles.font16BlackSemiBold(
                      context,
                    ).copyWith(overflow: TextOverflow.ellipsis),
                  ),
                  Text(data.brand, style: AppStyles.font11GreyMedium(context)),
                  const SizedBox(height: 8),
  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RatingAndReview(
                        rating: data.rating.toInt(),
                        reviewCount: data.reviewCount,
                      ),
                      const SizedBox(height: 8),
                      ProductPrice(
                        price: data.price,
                        discountValue: data.discountValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }
}

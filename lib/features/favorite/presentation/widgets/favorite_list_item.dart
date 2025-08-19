import 'package:e_commerce/core/widgets/cached_image_widget.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/presentation/widgets/home_list_view_item.dart';
import '../controller/favorite_controller.dart';

class FavoriteListItem extends StatelessWidget {
  const FavoriteListItem(this.product, {super.key});
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return Consumer(
    builder: (context, ref, child) {
      return Dismissible(
        key: Key(product.id),
        direction: DismissDirection.endToStart,
  
        background: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: AlignmentDirectional.centerEnd,
          padding: EdgeInsets.only(right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.white, size: 24.sp),
              SizedBox(height: 4.h),
              Text(
                AppStrings.kRemove,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          return await showFavoriteConfirmationDialog(context, ref, product.id);
        },
        onDismissed: (direction) {
          ref
              .read(
                favoritesControllerProvider(
                  FirebaseAuth.instance.currentUser!.uid,
                ).notifier,
              )
              .removeFavorite(product.id);
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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
                          imgUrl: product.imageUrls.values.first.first,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.name,
                                    style: AppStyles.font16BlackSemiBold(
                                      context,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  child: GestureDetector(
                                    child: const Icon(Icons.close),
                                    onTap: () {
                                      showFavoriteConfirmationDialog(
                                        context,
                                        ref,
                                        product.id,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              product.brand,
                              style: AppStyles.font11GreyMedium(context),
                            ),
                            RatingAndReview(
                              rating: product.rating.toInt(),
                              reviewCount: product.reviewCount,
                            ),
                            ProductPrice(
                              price: product.price,
                              discountValue: product.discountValue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 0,
              end: 0,
              child: CircleAvatar(
                child: Icon(
                  Icons.local_mall_rounded,
                  color: themeColors.onSecondary,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
  }
  Future<bool> showFavoriteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    String productId,
  ) async {
    final ThemeData theme = Theme.of(context);

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            title: Row(
              children: <Widget>[
                const Icon(Icons.favorite_border, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(
                  AppStrings.kRemoveFromFavorites,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Padding(
              padding:  EdgeInsets.only(bottom: 16.h),
              child: Text(
                AppStrings.kRemoveFromFavoritesConfirmation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ),
            actions: <Widget>[
              // Row for placing buttons side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Wrap the first button in an Expanded or Flexible widget
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(false),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: theme.colorScheme.primary),
                      ),
                      child: Text(
                        AppStrings.kCancel,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w), // Add spacing between buttons
                  // Wrap the second button in an Expanded or Flexible widget
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        AppStrings.kRemove,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );

    if (result == true) {
      await ref
          .read(
            favoritesControllerProvider(
              FirebaseAuth.instance.currentUser!.uid,
            ).notifier,
          )
          .removeFavorite(productId);
    }

    return result ?? false;
  }
}

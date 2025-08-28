import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewImageSection extends StatelessWidget {
  const ReviewImageSection({
    super.key,
    required this.selectedImages,
    required this.onRemoveImage,
    required this.onAddPhoto,
  });

  final List<String> selectedImages;
  final ValueChanged<String> onRemoveImage;
  final VoidCallback onAddPhoto;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 104.h,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (selectedImages.isNotEmpty) ..._buildExistingImages(context),
          _buildAddPhotoButton(context),
        ],
      ),
    ),
  );

  List<Widget> _buildExistingImages(BuildContext context) =>
      selectedImages
          .map(
            (imageUrl) => AspectRatio(
              aspectRatio: 1.1,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.color.secondary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: const Icon(Icons.image_not_supported),
                            ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(imageUrl),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList();

  Widget _buildAddPhotoButton(BuildContext context) => InkWell(
    onTap: onAddPhoto,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.onSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 15.h),
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25.r,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Icon(
                    Icons.camera_alt,
                    color: context.color.onSecondary,
                  ),
                ),
              ),
            ),
            Text(
              AppStrings.kAddYourPhotos,
              style: AppStyles.font11BlackSemiBold(context),
            ),
          ],
        ),
      ),
    ),
  );
}

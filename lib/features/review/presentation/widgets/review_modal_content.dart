import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/review_entity.dart';
import '../providers/review_form_provider.dart';
import 'review_rating_bar.dart';
import 'review_action_buttons.dart';
import 'review_image_section.dart';

class ReviewModalContent extends ConsumerStatefulWidget {
  const ReviewModalContent({
    super.key,
    required this.currentUserReview,
    required this.onSubmit,
    required this.onDelete,
  });

  final ReviewEntity? currentUserReview;
  final Function(String content) onSubmit;
  final VoidCallback onDelete;

  @override
  ConsumerState<ReviewModalContent> createState() => _ReviewModalContentState();
}

class _ReviewModalContentState extends ConsumerState<ReviewModalContent> {
  late final TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController(
      text: widget.currentUserReview?.content ?? '',
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ReviewFormState formState = ref.watch(reviewFormProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildModalTitle(context),
              const SizedBox(height: 8),
              ReviewRatingBar(
                initialRating: formState.rating,
                onRatingUpdate:
                    (double rating) => ref
                        .read(reviewFormProvider.notifier)
                        .updateRating(rating),
              ),
              SizedBox(height: 20.h),
              _buildContentLabel(context),
              SizedBox(height: 20.h),
              _buildTextField(context),
              SizedBox(height: 20.h),
              ReviewImageSection(
                selectedImages: formState.selectedImages,
                onRemoveImage:
                    (String imageUrl) => ref
                        .read(reviewFormProvider.notifier)
                        .removeImage(imageUrl),
                onAddPhoto: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Image picker not implemented yet'),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              ReviewActionButtons(
                currentUserReview: widget.currentUserReview,
                onSubmit: () => widget.onSubmit(_reviewController.text.trim()),
                onDelete: widget.onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalTitle(BuildContext context) => Text(
    widget.currentUserReview != null
        ? AppStrings.kEditYourReview
        : AppStrings.kWhatIsYourRate,
    style: AppStyles.font18BlackSemiBold(context),
    textAlign: TextAlign.center,
  );

  Widget _buildContentLabel(BuildContext context) => Text(
    AppStrings.kPleaseShareYourOpinionAboutTheProduct,
    style: AppStyles.font18BlackSemiBold(context),
    textAlign: TextAlign.center,
  );

  Widget _buildTextField(BuildContext context) => TextField(
    controller: _reviewController,
    maxLines: 10,
    enableInteractiveSelection: true,
    decoration: InputDecoration(
      hintText: 'Write your review here...',
      filled: true,
      fillColor: context.color.onSecondary.withValues(alpha: 0.1),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    ),
  );
}

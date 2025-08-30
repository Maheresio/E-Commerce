import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/review_entity.dart';
import '../providers/review_form_provider.dart';
import 'review_action_buttons.dart';
import 'review_rating_bar.dart';

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
              ReviewModalTitle(currentUserReview: widget.currentUserReview),
              const SizedBox(height: 8),
              ReviewRatingBar(
                initialRating: formState.rating,
                onRatingUpdate:
                    (double rating) => ref
                        .read(reviewFormProvider.notifier)
                        .updateRating(rating),
              ),
              SizedBox(height: 20.h),
              const ReviewContentLabel(),
              SizedBox(height: 20.h),
              ReviewContentTextField(controller: _reviewController),
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
}

class ReviewModalTitle extends StatelessWidget {
  const ReviewModalTitle({super.key, required this.currentUserReview});
  final ReviewEntity? currentUserReview;

  @override
  Widget build(BuildContext context) => Text(
    currentUserReview != null
        ? AppStrings.kEditYourReview
        : AppStrings.kWhatIsYourRate,
    style: AppStyles.font18BlackSemiBold(context),
    textAlign: TextAlign.center,
  );
}

class ReviewContentLabel extends StatelessWidget {
  const ReviewContentLabel({super.key});

  @override
  Widget build(BuildContext context) => Text(
    AppStrings.kPleaseShareYourOpinionAboutTheProduct,
    style: AppStyles.font18BlackSemiBold(context),
    textAlign: TextAlign.center,
  );
}

class ReviewContentTextField extends StatelessWidget {
  const ReviewContentTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: 10,
    enableInteractiveSelection: true,
    decoration: InputDecoration(
      hintText: AppStrings.kWriteYourReviewHere,
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

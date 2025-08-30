import '../../../../core/widgets/styled_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import '../providers/select_image_controller.dart';

class SearchViewBody extends ConsumerWidget {
  const SearchViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(isLoadingProvider);
    final SelectImageController controller = ref.read(
      selectImageControllerProvider,
    );

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(AppImages.searchBackground, fit: BoxFit.cover),

        if (isLoading) const Center(child: StyledLoading()),

        if (!isLoading)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppStrings.kSearchForAnOutfit,
                  style: AppStyles.font24WhiteSemiBold(context),
                ),
                const SizedBox(height: 28),
                CircularElevatedButton(
                  text: AppStrings.kTakePhoto.toUpperCase(),
                  onPressed:
                      () => controller.imageSelectionHandler(
                        context,
                        ImageSource.camera,
                      ),
                ),
                const SizedBox(height: 16),
                CircularElevatedButton(
                  text: AppStrings.kUploadAnImage.toUpperCase(),
                  color: Colors.transparent,
                  borderColor: Colors.white,
                  onPressed:
                      () => controller.imageSelectionHandler(
                        context,
                        ImageSource.gallery,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

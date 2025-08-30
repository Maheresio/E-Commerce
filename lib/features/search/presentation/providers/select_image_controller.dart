import '../../../../core/routing/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/methods/styled_snack_bar.dart';

class SelectImageController {
  SelectImageController(this.ref);
  final Ref ref;

  Future<void> imageSelectionHandler(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      ref.read(isLoadingProvider.notifier).state = true;
      final ImagePicker picker = ImagePicker();
      final photo = await picker.pickImage(source: source);
      ref.read(isLoadingProvider.notifier).state = false;

      if (photo != null && context.mounted) {
        await context.push(AppRoutes.cropImage, extra: photo.path);
      } else if (context.mounted) {
        // Handle case when no image is selected
        openStyledSnackBar(
          context,
          text: 'No image selected',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      ref.read(isLoadingProvider.notifier).state = false;
      if (context.mounted) {
        openStyledSnackBar(
          context,
          text: 'Error selecting image: $e',
          type: SnackBarType.error,
        );
      }
    }
  }
}

final StateProvider<bool> isLoadingProvider = StateProvider<bool>(
  (ref) => false,
);

final Provider<SelectImageController> selectImageControllerProvider =
    Provider<SelectImageController>(SelectImageController.new);

import 'package:e_commerce/core/routing/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


class SelectImageController {
  SelectImageController(this.ref);
  final Ref ref;

  Future<void> imageSelectionHandler(
    BuildContext context,
    ImageSource source,
  ) async {
    ref.read(isLoadingProvider.notifier).state = true;
    final ImagePicker picker = ImagePicker();
    final photo = await picker.pickImage(source: source);
    ref.read(isLoadingProvider.notifier).state = false;

    if (photo != null && context.mounted) {
      await context.push(AppRoutes.cropImage, extra: photo.path);
    }
  }
}

final StateProvider<bool> isLoadingProvider = StateProvider<bool>(
  (ref) => false,
);

final Provider<SelectImageController> selectImageControllerProvider =
    Provider<SelectImageController>(SelectImageController.new);

// search_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/routing/app_router.dart';

class SelectImageController {
  final Ref ref;
  SelectImageController(this.ref);

  Future<void> imageSelectionHandler(
    BuildContext context,
    ImageSource source,
  ) async {
    ref.read(isLoadingProvider.notifier).state = true;
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: source);
    ref.read(isLoadingProvider.notifier).state = false;

    if (photo != null && context.mounted) {
      context.push(AppRouter.kCropImageView, extra: photo.path);
    }
  }
}

final isLoadingProvider = StateProvider<bool>((ref) => false);

final selectImageControllerProvider = Provider<SelectImageController>(
  (ref) => SelectImageController(ref),
);

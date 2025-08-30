import '../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/widgets/styled_loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../checkout/presentation/widgets/styled_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../providers/search_provider.dart';

class CropImageView extends ConsumerStatefulWidget {
  const CropImageView({super.key, required this.imagePath});
  final String imagePath;

  @override
  ConsumerState<CropImageView> createState() => _CropImageViewState();
}

class MainContentWidget extends StatelessWidget {
  final String? errorMessage;
  final bool isCropped;
  final Uint8List? croppedImageBytes;
  final Widget cropImageWidget;
  final VoidCallback onClearError;
  const MainContentWidget({
    super.key,
    required this.errorMessage,
    required this.isCropped,
    required this.croppedImageBytes,
    required this.cropImageWidget,
    required this.onClearError,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              AppStrings.kErrorLoadingImage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onClearError,
              child: const Text(AppStrings.kTryAgain),
            ),
          ],
        ),
      );
    }
    if (isCropped) {
      return Image.memory(croppedImageBytes!, fit: BoxFit.cover);
    }
    return cropImageWidget;
  }
}

class CropImageWidget extends StatelessWidget {
  final String imagePath;
  final CropController controller;
  final void Function(String) onError;
  const CropImageWidget({
    super.key,
    required this.imagePath,
    required this.controller,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);
    if (!file.existsSync()) {
      onError(AppStrings.kImageFileNotFound);
      return const SizedBox.shrink();
    }
    try {
      return CropImage(
        controller: controller,
        image: Image.file(file, fit: BoxFit.cover),
        gridColor: Colors.white,
        gridCornerColor: Colors.blueAccent,
        showCorners: true,
        gridCornerSize: 30,
        gridThinWidth: 2,
        gridThickWidth: 5,
        scrimColor: Colors.black.withValues(alpha: 0.5),
        alwaysShowThirdLines: false,
      );
    } catch (e) {
      onError(
        AppStrings.kErrorLoadingImageGeneric.replaceFirst('%s', e.toString()),
      );
      return const SizedBox.shrink();
    }
  }
}

class _CropImageViewState extends ConsumerState<CropImageView> {
  final CropController controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  Uint8List? _croppedImageBytes;
  bool _isCropped = false;
  bool isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: styledAppBar(context, title: AppStrings.kCropItem),
    body: Stack(
      fit: StackFit.expand,
      children: [
        _buildMainContent(),

        if (isLoading) ...[
          const ModalBarrier(dismissible: false, color: Colors.black45),
          const Center(child: StyledLoading()),
        ],
      ],
    ),
    bottomNavigationBar: Container(
      height: 100.h,
      padding: const EdgeInsets.all(12),
      color: Colors.grey[100],
      child: Center(
        child: InkWell(
          splashColor: context.color.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(30),
          onTap: _isCropped ? _onSearchPressed : _onCropPressed,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: context.color.primary,
            child: Icon(
              _isCropped ? Icons.search_outlined : Icons.check,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildMainContent() {
    return MainContentWidget(
      errorMessage: _errorMessage,
      isCropped: _isCropped,
      croppedImageBytes: _croppedImageBytes,
      cropImageWidget: CropImageWidget(
        imagePath: widget.imagePath,
        controller: controller,
        onError: (msg) => setState(() => _errorMessage = msg),
      ),
      onClearError: () => setState(() => _errorMessage = null),
    );
  }

  Future<void> _onCropPressed() async {
    if (_isCropped) return;

    setState(() {
      isLoading = true;
    });

    try {
      final bitmap = await controller.croppedBitmap();

      // Add memory management for large images
      if (bitmap.width > 1024 || bitmap.height > 1024) {
        final resizedBitmap = await _resizeImage(bitmap, 1024, 1024);
        final byteData = await resizedBitmap.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData == null) {
          throw Exception(AppStrings.kFailedToConvertResizedImage);
        }

        setState(() {
          isLoading = false;
          _croppedImageBytes = byteData.buffer.asUint8List();
          _isCropped = true;
        });
      } else {
        final byteData = await bitmap.toByteData(
          format: ui.ImageByteFormat.png,
        );

        if (byteData == null) {
          throw Exception(AppStrings.kFailedToConvertImage);
        }

        setState(() {
          isLoading = false;
          _croppedImageBytes = byteData.buffer.asUint8List();
          _isCropped = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      openStyledSnackBar(
        context,
        text: '${AppStrings.kCroppingFailed}: $e',
        type: SnackBarType.error,
      );
    }
  }

  Future<ui.Image> _resizeImage(
    ui.Image image,
    int maxWidth,
    int maxHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final double scaleX = maxWidth / image.width;
    final double scaleY = maxHeight / image.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double newWidth = image.width * scale;
    final double newHeight = image.height * scale;

    canvas.scale(scale);
    canvas.drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    return await picture.toImage(newWidth.round(), newHeight.round());
  }

  void _onSearchPressed() {
    if (_croppedImageBytes == null) {
      openStyledSnackBar(
        context,
        text: AppStrings.kNoCroppedImageAvailable,
        type: SnackBarType.error,
      );
      return;
    }

    ref.read(searchProvider.notifier).processImage(_croppedImageBytes!);
    context.pop();
    context.push(AppRoutes.searchResult);
  }
}

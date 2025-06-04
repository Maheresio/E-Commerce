import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/core/routing/app_router.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:e_commerce/core/helpers/extensions/theme_color.extension.dart';
import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:e_commerce/features/checkout/presentation/widgets/checkout_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../providers/search_provider.dart';

class CropImageView extends ConsumerStatefulWidget {
  final String imagePath;

  const CropImageView({super.key, required this.imagePath});

  @override
  ConsumerState<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends ConsumerState<CropImageView> {
  final CropController controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  Uint8List? _croppedImageBytes;
  bool _isCropped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkoutAppBar(context, AppStrings.kCropItem),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _isCropped
              ? Image.memory(_croppedImageBytes!, fit: BoxFit.cover)
              : CropImage(
                controller: controller,
                image: Image.file(File(widget.imagePath), fit: BoxFit.cover),
                gridColor: Colors.white,
                gridCornerColor: Colors.blueAccent,
                showCorners: true,
                gridCornerSize: 30,
                gridThinWidth: 2,
                gridThickWidth: 5,
                scrimColor: Colors.black.withValues(alpha: 0.5),
                alwaysShowThirdLines: false,
                onCrop: (rect) => debugPrint('Crop changed: $rect'),
              ),
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
  }

  Future<void> _onCropPressed() async {
    if (_isCropped) return;

    try {
      final ui.Image bitmap = await controller.croppedBitmap();
      final ByteData? byteData = await bitmap.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to convert image to bytes.');
      }

      setState(() {
        _croppedImageBytes = byteData.buffer.asUint8List();
        _isCropped = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cropping failed: $e')));
    }
  }

  void _onSearchPressed()  {
     ref.read(searchProvider.notifier).processImage(_croppedImageBytes!);

    context.push(AppRouter.kSearchResultView);
  }
}

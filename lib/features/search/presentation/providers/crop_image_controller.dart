import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../../core/services/firestore_sevice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/services/supabase_storage_service.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../data/repositories/search_repository_impl.dart';

class CropImageState {
  CropImageState({
    this.isLoading = false,
    this.isCropped = false,
    this.croppedBytes,
    this.errorMessage,
  });
  final bool isLoading;
  final bool isCropped;
  final Uint8List? croppedBytes;
  final String? errorMessage;

  CropImageState copyWith({
    bool? isLoading,
    bool? isCropped,
    Uint8List? croppedBytes,
    String? errorMessage,
  }) => CropImageState(
    isLoading: isLoading ?? this.isLoading,
    isCropped: isCropped ?? this.isCropped,
    croppedBytes: croppedBytes ?? this.croppedBytes,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

class CropImageController extends AutoDisposeNotifier<CropImageState> {
  CropImageController(this._repo);
  final SearchRepositoryImpl _repo;

  @override
  CropImageState build() => CropImageState();

  Future<String?> cropImage(ui.Image bitmap) async {
    try {
      if (bitmap.width <= 0 || bitmap.height <= 0) {
        return 'Invalid image dimensions.';
      }

      final ByteData? byteData = await bitmap.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        return 'Failed to convert image.';
      }

      final Uint8List cropped = byteData.buffer.asUint8List();

      if (cropped.isEmpty) {
        return 'Cropped image is empty.';
      }

      state = state.copyWith(
        croppedBytes: cropped,
        isCropped: true,
        errorMessage: null,
      );
      return null;
    } catch (e) {
      final errorMsg = 'Cropping failed: $e';
      state = state.copyWith(errorMessage: errorMsg);
      return errorMsg;
    }
  }

  Future<String?> uploadImage() async {
    if (state.croppedBytes == null || state.croppedBytes!.isEmpty) {
      return 'No image to upload.';
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _repo.uploadImage(state.croppedBytes!);
      return null;
    } catch (e) {
      final errorMsg = 'Upload failed: $e';
      state = state.copyWith(errorMessage: errorMsg);
      return errorMsg;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final AutoDisposeNotifierProvider<CropImageController, CropImageState>
cropImageControllerProvider =
    NotifierProvider.autoDispose<CropImageController, CropImageState>(
      () => CropImageController(
        SearchRepositoryImpl(
          SearchRemoteDataSourceImpl(
            dioClient: DioClient(),
            storageService: SupabaseStorageService(),
            firestore: FirestoreServices.instance,
          ),
        ),
      ),
    );

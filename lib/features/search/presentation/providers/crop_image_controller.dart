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
  });
  final bool isLoading;
  final bool isCropped;
  final Uint8List? croppedBytes;

  CropImageState copyWith({
    bool? isLoading,
    bool? isCropped,
    Uint8List? croppedBytes,
  }) => CropImageState(
    isLoading: isLoading ?? this.isLoading,
    isCropped: isCropped ?? this.isCropped,
    croppedBytes: croppedBytes ?? this.croppedBytes,
  );
}

class CropImageController extends AutoDisposeNotifier<CropImageState> {
  CropImageController(this._repo);
  final SearchRepositoryImpl _repo;

  @override
  CropImageState build() => CropImageState();

  Future<String?> cropImage(ui.Image bitmap) async {
    try {
      final ByteData? byteData = await bitmap.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return 'Failed to convert image.';
      final Uint8List cropped = byteData.buffer.asUint8List();

      state = state.copyWith(croppedBytes: cropped, isCropped: true);
      return null;
    } catch (_) {
      return 'Cropping failed.';
    }
  }

  Future<String?> uploadImage() async {
    if (state.croppedBytes == null) return 'No image to upload.';

    state = state.copyWith(isLoading: true);
    try {
      await _repo.uploadImage(state.croppedBytes!);
      return null;
    } catch (_) {
      return 'Upload failed.';
    } finally {
      state = state.copyWith(isLoading: false);
    }
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

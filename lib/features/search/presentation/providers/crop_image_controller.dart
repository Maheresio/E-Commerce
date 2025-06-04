import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/network/dio_client.dart';
import 'package:e_commerce/core/services/supabase_storage_service.dart';
import 'package:e_commerce/features/search/data/datasources/search_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/search_repository_impl.dart';

class CropImageState {
  final bool isLoading;
  final bool isCropped;
  final Uint8List? croppedBytes;

  CropImageState({
    this.isLoading = false,
    this.isCropped = false,
    this.croppedBytes,
  });

  CropImageState copyWith({
    bool? isLoading,
    bool? isCropped,
    Uint8List? croppedBytes,
  }) {
    return CropImageState(
      isLoading: isLoading ?? this.isLoading,
      isCropped: isCropped ?? this.isCropped,
      croppedBytes: croppedBytes ?? this.croppedBytes,
    );
  }
}

class CropImageController extends AutoDisposeNotifier<CropImageState> {
  final SearchRepositoryImpl _repo;

  CropImageController(this._repo);

  @override
  CropImageState build() => CropImageState();

  Future<String?> cropImage(ui.Image bitmap) async {
    try {
      final byteData = await bitmap.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return 'Failed to convert image.';
      final cropped = byteData.buffer.asUint8List();

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




// TODO: Recfactor this code  

final cropImageControllerProvider =
    NotifierProvider.autoDispose<CropImageController, CropImageState>(
      () => CropImageController(
        SearchRepositoryImpl(
          SearchRemoteDataSourceImpl(
            dioClient: DioClient(),
            storageService: SupabaseStorageService(),
            firestore: FirebaseFirestore.instance,
          ),
        ),
      ),
    );



